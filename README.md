# MCATools
Various tools used for Minecraft Comes Alive mod development.

# Zombifier
Requires [LÖVE](https://love2d.org/).

Batch-converts Minecraft skins into zombified versions.
Specify imported directories in `main.lua`. Exports into `%appData%` dir.


# LangPorter
Requires [LÖVE](https://love2d.org/).

Maps JSON translation files. Because we keep renaming stuff.

Create following dir to use:
* `source` containing the old english files. Those are used to detect renamed keys.
* `target` containing the english target files. Those define the new file and keys.
* `translations` containing the old translations in the format of `source`, each in their own dir named as the language.

Outputs two directiors:
* `output` uses the `source` format as used for [Crowdin](https://crowdin.com/project/minecraft-comes-alive-2).
* `outputMinecraft` uses the format used in the mod itself.

`mapping.json` defines the directory name the json file gets named.