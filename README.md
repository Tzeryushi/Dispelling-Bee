# Dispelling-Bee
 Counter enemy spells! Bee the best you can bee!

## Abstract:
Dispelling Bee is a rpg-style typing game where the player must rapid-fire type out spell names to damage enemies, while also dispelling enemies’ spells by typing them backwards before they have a chance to fire them themselves.

The player plays as Apicurio the Great, a bee from a long and distinguished line of anti-mages from the Great Hive that is tasked with reigning in rampaging wizards that disrespect the balance of nature and magic.

## Limitations:
The core of the game is based on somewhat of a gimmick, and is not geared for holding the attention of the player for long past its initial impact, unless they are a typing enthusiast. As such, the gameplay loop must be quick and momentum-based, and the overall game must resolve itself rather quickly and not overstay its welcome.

Attention must also be paid to the accessibility of the game, as speedy typing is definitely not ubiquitous. Early challenges must ease the player into the game's difficulty in order to prevent front-loaded frustration.

## Assets:
- RPG Battle screen-esque system
- This is time-based, not turn-based.
- Enemies (function as “levels” in essence), at least 3
- These enemies should vary in word complexity
- Time permitting, unique elements, such as obscuring the words, can be added
- Spellbook with “pages” that contain simple or complex spells
- Power is attributed to spells with more complexity
- Win states
- Fail states (these should be non-punishing beyond having to attempt to engage the enemy again)

## Core Loop:
The player interacts with an enemy in the overworld. This ultimately sends them to the battle screen, where the enemy will begin reciting a spell (words encapsulated in a speech bubble), and the countdown to its completion will be denoted by a timer in the corner. Before the timer finishes counting down, the player must dispel the incantation by typing it in backwards, making the spell fizzle out. However, the countdown sometimes takes a while, so the player must type spells from their own spellbook to damage the enemy in the interim. The player must also juggle a resource known as honey, which fuels their spells. This resource increases slowly over time but is consumed upon casting a spell. The bar will be refilled somewhat if an enemy spell is dispelled.

Engagement results from juggling defense and offense as the player must weigh the risks of time and their personal resources. Skilled players will be able to maximize their offense by dispelling only when more honey is needed, while relaxed players may take their time in battles by playing defensively and waiting for slow-casting spells to mount an offense.

After a win state, where the player reduces the enemy’s health to 0, the game will return to the overworld and an avenue of progression to the next battle will be opened.

## Spellbook:
The spellbook refers to the spells that players are given the option to cast in battle. These are basically dictionaries that contain a number of phrases that are randomly selected from and provided as prompts to the player to type out during gameplay.
The spellbook can be manipulated out of combat as a pseudo-difficulty modifier. The player will be able to select “pages” that have varying levels of complexity. Easy to type phrases will do less damage, however, and difficult phrases will do more.

## Brainstorming
Some enemy spells cast faster than others, and must be prioritized over attacking
Visual elements may obscure or manipulate on screen text to provide obstacles to the player
Spellbooks with stronger spells but more complicated incantations
Optional battles that provide upgrades to spell damage, health and honey capacity upon completion
