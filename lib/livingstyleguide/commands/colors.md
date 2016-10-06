# Colors

You can automatically generate color swatches out of your Sass variables:

``` raw:lsg
@colors {
  $light-red  $gray  $green  $red  $dark-red  $black
}
```

By clicking the color swatch in the style guide, users can copy the hex code of
the color (useful for designers). When pointing the cursor on the variable name,
it will be copied on click instead (useful for developers).

The output will respect newlines. The example below will create a 3 × 3 matrix
of color swatches and groups shades in columns which might be more easy to
understand. `-` leaves a cell empty in the matrix:

``` raw:lsg
@colors {
  -       $light-red  $gray
  $green  $red        -
  -       $dark-red   $black
}
```

The LivingStyleGuide also supports CSS colors and Sass functions. All of them
will work:

``` raw:lsg
@colors {
  red        #ca1f70              #FFF               rgba(0, 0, 0, 0.5)
  $my-color  my-color-function()  lighten(red, 10%)  darken($my-color, 20%)
}
```
