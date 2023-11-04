# Musedown [![Gem Version](https://badge.fury.io/rb/musedown.svg)](https://badge.fury.io/rb/musedown)

`Musedown` is a MuseScore 3/4 CLI wrapper that transforms markdown files that contain references to MuseScore music notation files into files that contain references to the notation rendered as `png`s.

When used as a Markdown preprocessor, `musedown`runs MuseScore, which reads the `.mscz` files, and exports rendered notation as `.png` images.

`Musedown` can also invoke MuseScore to perform the conversion without requiring a markdown file.


## Installation

To install the `gem` from [RubyGems.org](https://rubygems.org):

```bash
$ gem install musedown
```

To build and install a local copy from the source code:

```bash
$ bundle exec rake install
```


## Markdown Usage

The `musedown` CLI will use MuseScore's CLI (`mscore`) to convert your `.mscz` files into `.png` files and replace them in your markdown file.

To use:

1. Make a reference to the `.mscz` file in a markdown file, as if it were an image. For example, imagine that the file `hello.md` contains:

   ```markdown
   ![Hello score](hello.mscz)
   ```

2. Run `musedown`, which will read `hello.md`, and convert all reference to `.mscz` files to `.png` files:

   ```markdown
   musedown build hello.md
   ```

3. Your markdown file will now be like this:

   ```markdown
   ![Hello score](hello-mscz-1.png)
   ```

The image `hello-mscz-1.png` will be automatically generated.
You may keep the `hello.mscz`, perform changes and re-run the command to refresh the `.png` file.


### Commands

To parse a file, run:

```script
$ musedown build FILE_NAME
```

The above modifies `FILE_NAME`, which may not be desirable.


#### -o Option

To route the output to another file:

```script
$ musedown build examples/hello.md -o result.md
```


#### -c Option

You can specify the path to the `mscore` executable with the `-c` flag.
This allows you to use `muse3` or `muse4`:

```script
$ musedown build examples/hello.md \
  -o examples/output.md \
  -c `which mscore3`
```

```script
$ musedown build examples/hello.md \
  -o examples/output.md \
  -c "/Applications/MuseScore\ 3.app/Contents/MacOS/mscore"
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/erickduran/musedown.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
