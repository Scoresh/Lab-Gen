# Welcome to Lab-Gen, a comprehensive markdown Lab Report generator!
This project was developed by Daniel Sabalakov, (Scoresh), as an extension to a project that I did over the summer.

## Requirements
Lab-Gen requires the following packages to be installed and added to PATH
+ Pandoc 
+ Any LaTeX distribution with lualatex
+ Java
+ C++
+ Lua
## Metadata Usage
### Brief Explanation
Metadata can be attached at the top of the file to specify certain commands to set custom commands.
### Explanation
Example of usage is below:
'''
\---
author: Daniel
date: 9/2
class: Class
\---
'''
But, fields aren't required.

### Supported Fields
The following fields are supported:
+ author
+ date
+ class
+ title
+ quote
## Commands
### Brief Explanation
Commands can be signified inline via the following syntax:
@!COMMAND_NAME
### Supported Commands
The following commands are supported:
+ @!toc ==> Macro command to generate a table of contents
+ @!raw *LATEX* !@ ==> Macro command to include raw LaTeX code into the markdown. Be sure to use double backslashes for commands.
+ @!image path=$PATH width=$WIDTH !@ ==> Macro command used to include images into the markdown.
<!-- + @!graph ==> Macro command to generate graphs !TODO: IMPLEMENT -->
### Supported Graphs
Graphs can also be generated using these macro commands. 
## Generation (Executable file)
Run the LabGen.exe file to run default recommended settings for Lab-Gen.  
## Generation (Batch File)
Run the batch script (generate.bat) to run default recommended settnigs for Lab-Gen. 
The following flags are supported (and case insentitive)
+ -color ==> sets color of flag
+ -cj ==> compile java code
+ -text ==> leave blank for Lab-Gen by default; any other text will be displayed
+ -file ==> leave blank for text.md by default; any other file will be specified to render an image properly.
## Generation (Command Line)
Since Lab-Gen uses Pandoc as its parser, we can run a Pandoc process to directly compile the markdown.
### Command Line
pandoc ^
<!-- PATH TO LaTeX Template -->
  --template=latex_templates/basetemplate.tex^
<!-- INPUT / OUTPUT PATHS -->
  --from markdown-smart-smart ../text.md -o ../text.pdf^
<!-- PDF ENGINE (LUALATEX RECOMMENDED) -->
  --pdf-engine=lualatex^
<!-- LUA FILTERS RAN. MORE WILL BE ADDED IN THE FUTURE. -->
  --lua-filter=lua_filters/preprocess.lua
## Future Plans!
The following features should be implemented in the feature
+ Python support using tkinter for a workable GUI
+ Selectable / Library built into the GUI for help
+ More meta tags, ability to include custom templates
+ More Commands, Graphs
+ Add bar graphs
