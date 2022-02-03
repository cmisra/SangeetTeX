# SangeetTeX

A LaTex engine for transcribing and rendering Indic Music Sheet. Currently it is in experimental phase and uses Tagore Songs as test bed. Next, we will use music-sheet written Bhatkhande, Paluskar, and Sargam notation systems. SangeetTeX serves as a base for structuring notation symbols on paper using Indic music theory and therefore can be applicable to other notation systems (of classical genres) with minor changes.

## How to install SangeetTeX

You require two font files:
1. [**Swarabitan.ttf**](https://rabindra-rachanabali.nltr.org/node/1) Used for annotating scores (uses Bangla script version of Akarmatrik Notation System)
2. [**Bangla.ttf**](https://www.omicronlab.com/bangla-fonts.html) Used for annotating lyrics (uses Bangla Unicode font and require Bangla Input Method like [Avro Keyboard](https://www.omicronlab.com/avro-keyboard.html))
3. You can use any Unicode Bangla Font to render the lyrics. However, since there is only one font available for score, you need to download **swarabitan.ttf**.
4. Create two folders in the same working directory where your .tex source file is placed. The name of the folders are - **BanglaFontFiles** and **Swarabitan**.
5. Download the **sangeet.cls** class file in the same working directory where your .tex source file is placed.
6. You are good to go.
