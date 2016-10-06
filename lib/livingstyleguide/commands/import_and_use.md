# Using external files

## Importing Files

You can import any other `*.lsg` file at any place within any `*.lsg` file:

``` raw:lsg
// Import a file:
@import folder/file.lsg

// Import a file (`.lsg` will be added by default):
@import folder/file

// Import a file starting with `_` (`folder/_file.lsg`); this works
// automatically:
@import folder/file

// Import multiple files:
@import folder/*.lsg
@import folder/*

// Importing from multiple folders:
@import **/*.lsg
@import **/*

// Importing a Haml file (the resulting HTML will be rendered into the style
// guide):
@import folder/file.haml
@import folder/*.haml
@import **/*.haml
```

All file types supported by [Tilt](https://github.com/rtomayko/tilt#readme) can
be imported. By default, `@import` is looking for `*.lsg` files.


## Tip

A possible structure which works well:

```
Project
|- atoms/
|  |- _button.scss
|  |- _button.lsg
|  |- _field.scss
|  |- _field.lsg
|  |- _...
|- components/
|  |- _...
|- atoms.lsg
|- components.lsg
```

The `atoms.lsg` could look like:

``` raw:lsg
# Atoms

@import atoms/**/*
```

## Using files

`@use` imports a file without parsing it. It works the same ways as if the code
of the external file would be right in place:

example.lsg

``` raw:lsg
@haml
- text = "Lorem"
%div= text
```

Would be identical to:

example.haml

``` raw:lsg
%div= text
```

example.lsg

``` raw:lsg
@haml
- text = "Lorem"
@use example.haml
```

If you want to reuse your partials in your style guide, `@use` will be your
friend.
