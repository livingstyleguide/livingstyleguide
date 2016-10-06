# Manipulating CSS per example

You can add any CSS to each example if it helps to make it better in the style guide only.
For example, add some margin between elements:

``` raw:lsg
<button class="button">Example button</button>
<button class="button -primary">Example button</button>
@css {
  .button + .button {
    margin-left: 3em;
  }
}
```

This adds `3em` margin between both buttons.
To avoid this to affect other examples, the CSS code will be scoped to this example only (each example automatically gets a unique id).

If you need the same CSS code for several examples, you can put the CSS outside of the example.
This way it will be scoped to the current file:

``` raw:lsg
\```
<button class="button">Example button</button>
<button class="button -primary">Example button</button>
\```

\```
<a class="button">Example button</a>
<a class="button -primary">Example button</a>
\```

@css {
  .button + .button {
    margin-left: 3em;
  }
}
```
