/* Consult this file and issue the command:   start.  */

:- dynamic at/2, i_am_at/1, alive/1.   /* Needed by SWI-Prolog. */
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).

/* This defines my current location. */

i_am_at(palace).


/* These facts describe how the rooms are connected. */

path(spider, d, cave).

path(cave, u, spider).
path(cave, w, cave_entrance).

path(cave_entrance, e, cave).
path(cave_entrance, s, palace).

path(palace, n, cave_entrance) :- at(flashlight, in_hand).
path(palace, n, cave_entrance) :-
        write('Go into that dark cave without a light?  Are you crazy?'), nl,
        !, fail.
path(palace, s, arena).

path(arena, n, palace).
path(arena, w, cage).
path(arena, s, mansion).
path(mansion, n, palace).
path(cage, e, arena).

path(closet, w, arena).

path(arena, e, closet) :- at(key, in_hand).
path(arena, e, closet) :-
        write('The door appears to be locked.'), nl,
        fail.


/* These facts tell where the various objects in the game
   are located. */

at(princess, spider).
at(key, cave_entrance).
at(flashlight, arena).
at(sword, closet).
at(magicwand,closet).

/* This fact specifies that the Cruel magician and spider are alive. */

alive(spider).
alive(magician).

/* These rules describe how to pick up an object. */

take(X) :-
        at(X, in_hand),
        write('You''re already holding it!'),
        nl, !.

take(X) :-
        i_am_at(Place),
        at(X, Place),
        retract(at(X, Place)),
        assert(at(X, in_hand)),
        write('OK.'),
        nl, !.

take(_) :-
        write('I don''t see it here.'),
        nl.


/* These rules describe how to put down an object. */

drop(X) :-
        at(X, in_hand),
        i_am_at(Place),
        retract(at(X, in_hand)),
        assert(at(X, Place)),
        write('OK.'),
        nl, !.

drop(_) :-
        write('You aren''t holding it!'),
        nl.


/* These rules define the six direction letters as calls to go/1. */

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).

u :- go(u).

d :- go(d).


/* This rule tells how to move in a given direction. */

go(Direction) :-
        i_am_at(Here),
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        look, !.

go(_) :-
        write('You can''t go that way.').


/* This rule tells how to look about you. */

look :-
        i_am_at(Place),
        describe(Place),
        nl,
        notice_objects_at(Place),
        nl.


/* These rules set up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
        at(X, Place),
        write('There is a '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(_).


/* These rules tell how to handle killing the lion and the spider. */

kill :-
        i_am_at(cage),
        write('Oh, bad idea!  You have just been eaten by a lion.'), nl,
        !, die.

kill :-
        i_am_at(cave),
        write('This isn''t working.  The spider leg is about as tough'), nl,
        write('as a telephone pole, too.').


kill:-
			i_am_at(mansion),
			at(magicwand, in_hand),
			retract(alive(magician)),
			write('You have had a long battle of wands & have managed to Disarm the Cruel Magician'),nl,
			write('Alohomora'),nl,
			write('Sectumsempra'),nl,
			write('You Finally use the below spells on the Cruel Magician & turn it into a Rat and finally Killed him'),nl,
			write('Riddikulus'),nl,
			write('Avada Kedavara'),nl.

kill :-
        i_am_at(mansion),
        write('Run! You can not win against the Cruel Magician without the magic_wand.'), nl.

kill :-
        i_am_at(spider),
        at(sword, in_hand),
        retract(alive(spider)),
        write('You hack repeatedly at the spider''s back.  Slimy ichor'), nl,
        write('gushes out of the spider''s back, and gets all over you.'), nl,
        write('I think you have killed it, despite the continued twitching.'),
        nl, !.

kill :-
        i_am_at(spider),
        write('Beating on the spider''s back with your fists has no'), nl,
        write('effect.  This is probably just as well.'), nl, !.

kill :-
        write('I see nothing inimical here.'), nl.


/* This rule tells how to die. */

die :-
        !, finish.


/* Under UNIX, the   halt.  command quits Prolog but does not
   remove the output window. On a PC, however, the window
   disappears before the final output can be seen. Hence this
   routine requests the user to perform the final  halt.  */

finish :-
        nl,
        write('The game is over. Please enter the   halt.   command.'),
        nl, !.


/* This rule just writes out game instructions. */

instructions :-
        nl,
        write('Enter commands using standard Prolog syntax.'), nl,
        write('Available commands are:'), nl,
        write('start.                   -- to start the game.'), nl,
        write('n.  s.  e.  w.  u.  d.   -- to go in that direction.'), nl,
        write('take(Object).            -- to pick up an object.'), nl,
        write('drop(Object).            -- to put down an object.'), nl,
        write('kill.                    -- to attack an enemy.'), nl,
        write('look.                    -- to look around you again.'), nl,
        write('instructions.            -- to see this message again.'), nl,
        write('halt.                    -- to end the game and quit.'), nl,
        nl.


/* This rule prints out instructions and tells where you are. */

start :-
        instructions,
        look.


/* These rules describe the various rooms.  Depending on
   circumstances, a room may have more than one description. */

describe(palace) :-
        at(princess, in_hand),
        write('Congratulations!!  You have freed the Princess'), nl,
        write('and won the game.'), nl,
        finish, !.

describe(palace) :-
        write('You are in a Palace.  To the north is the dark mouth'), nl,
        write('of a cave; to the south is a small Arena.  Your').

describe(arena) :-
        write('You are in a small Arena.  The exit is to the north.'), nl,
        write('There is a barred door to the west, but it seems to be'), nl,
        write('unlocked.  There is a smaller door to the east.'), nl,
		write('There is the Mansion of the Cruel Magician at South. Be careful you might need something!').

describe(cage) :-
        write('You are in a lion''s den!  The lion has a lean and'), nl,
        write('hungry look.  You better get out of here!'), nl.

describe(closet) :-
        write('This is nothing but an old storage closet.'), nl.

describe(cave_entrance) :-
        write('You are in the mouth of a dank cave.  The exit is to'), nl,
        write('the south; there is a large, dark, round passage to'), nl,
        write('the east.'), nl.

describe(cave) :-
        alive(spider),
        at(princess, in_hand),
        write('The spider sees you with the Princess and attacks!!!'), nl,
        write('    ...it is over in seconds....'), nl,
        die.

describe(cave) :-
        alive(spider),
        write('There is a giant spider here!  One hairy leg, about the'), nl,
        write('size of a telephone pole, is directly in front of you!'), nl,
        write('I would advise you to leave promptly and quietly....'), nl, !.
describe(cave) :-
        write('Yecch!  There is a giant spider here, twitching.'), nl.


describe(mansion):-
			alive(magician),
			write('You can not fight magician without magic_wand, You were trapped and killed'),
			die.

describe(mansion):-
			alive(magician),
			write('You are at the Cruel Magicians mansion'),nl,
			write('The Mansoin is a spine-chilling with pin drop silence'),nl,
			write('You hear a loud thunder and the Cruel Magician appears in front of you'),nl,
			write('You can either go and get back to the Palace (n.) or'),nl,
			write('challenge the Cruel Magician for a Duel Combact (kill)'),nl.

describe(spider) :-
        alive(spider),
        write('You are on top of a giant spider, standing in a rough'), nl,
        write('mat of coarse hair.  The smell is awful.'), nl.

describe(spider) :-
        write('Oh, gross!  You''re on top of a giant dead spider!'), nl.




