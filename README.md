# Musedown
This is a simple MuseScore CLI wrapper to easily build markdown files with music notation (and preserve for changes).

## Installation
To install the `gem` directly from [RubyGems.org](https://rubygems.org):
```bash
gem install musedown
```

Or build directly from the source code:
```bash
rake install
```

## Usage
The `musedown` CLI will use MuseScore's CLI (`mscore`) to convert your `.mscz` files into `.png` files and replace them in your markdown file. 

To use:
1. Embed the `.mscz` file into your markdown like this:
```markdown
![Awesome score](hello.mscz)
```
2. Run `musedown`:
```
musedown build hello.md
```
3. And your markdown file will now be like this:
```markdown
![Awesome score](hello-mscz-1.png)
```
And the `hello-mscz-1.png` will be automatically generated. You may keep the `hello.mscz`, perform changes and re-run the command to refresh the `.png` file.

### Commands
To parse a file, simply run:
```bash
musedown build FILE_NAME
```

To route the output to another file:
```bash
musedown build examples/hello.md -o result.md
```

If `mscore` is not available, you can directly pass the executable with the `-c` flag:
```bash
musedown build examples/hello.md -o examples/output.md -c "/Applications/MuseScore\ 3.app/Contents/MacOS/mscore"
```

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/erickduran/musedown.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
