# SangeetTeX

A LaTex engine for transcribing and rendering Indic Music Sheet. Currently it is in experimental phase and uses _Tagore Songs_ as test bed. Next, we will use music-sheet written _Bhatkhande_, _Paluskar_, and _Sargam_ notation systems. **SangeetTeX** serves as a base for structuring notation symbols on paper using Indic music theory and therefore can be applicable to other notation systems (of classical genres) with minor changes.

## How to install SangeetTeX

You require two font files:
1. [**Swarabitan.ttf**](https://rabindra-rachanabali.nltr.org/node/1) Used for annotating scores (uses Bangla script version of Akarmatrik Notation System)
2. [**Bangla.ttf**](https://www.omicronlab.com/bangla-fonts.html) Used for annotating lyrics (uses Bangla Unicode font and require Bangla Input Method like [Avro Keyboard](https://www.omicronlab.com/avro-keyboard.html))
3. You can use any Unicode Bangla Font to render the lyrics. However, since there is only one font available for score, you need to download **swarabitan.ttf**.
4. Create two folders in the same working directory where your .tex source file is placed. The name of the folders are - **BanglaFontFiles** and **Swarabitan**.
5. Download the **sangeet.cls** class file in the same working directory where your .tex source file is placed.
6. You are good to go.

## Primary environment and commands for creating music-sheet

Primary environment (only one currently) **sangeetTeX** is **sangeet**. There are two primary commands that can be used to write a single line of the composition:

1. Line having score only. `\scoreLine`
2. Line having score and lyric. `\scoreLyricLine`

Each of the above two commands has two versions:

1. Creating a new phrase of the composition having only score: `\scoreNewPhrase` and having both score and lyric: `\scoreLyricNewPhrase`.
2. Ending a phrase having only score: `\scoreEndPhrase` and having both score and lyric `\scoreLyricEndPhrase`.
3. We try to create options in the commands `\scoreLine` and `scoreLyricLine` so that we do not require these versions anymore and thus eliminating much of the duplicate code.

## Use Cases

### Writing score only

**input:** _Dadra_ tal, number of _avartan_ is 1, and the score symbols at each beat of the tal

`\scoreline{dadra}{1}{na,-a,-a,sfa,-a,-vfa}`

### Writing score as well as lyrics

**input:** _jhap_ tal, number of _avartan_ is 2, and the score symbols and the lyric letter at each beat of the tal

`\scoreLyricLine{jhap}{2}{PHsa,-a,sa,Snha,sa,rga,-mpa,ma,ga,-a}{বি,শ,শ,বী,ণা,বা০,০০,জি,ছে,০}`

### Rendering Meend Symbol

**input:** _dadra_ tal, number of _avartan_ is 2, and the score symbols and the lyric letter at each beat of the tal

``\scoreLyricLine{dadra}{2}{sa,`sa,`-ra,ra,ra,-a,ra,-a,-ga,Gra,-ma,ga}{অ,নে,ক,দি,নে,র,আ,০,০,মা,র,যে}``

The start and end of the Meend symbol is distated by the inclusion of the symbol ` inside score input.
