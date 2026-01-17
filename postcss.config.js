import postcssImport from "postcss-import"
import postcssNesting from "postcss-nesting"
import autoprefixer from "autoprefixer"
import tailwindcss from "@tailwindcss/postcss"

export default {
  plugins: [
    postcssImport,
    postcssNesting,
    tailwindcss,
    autoprefixer,
  ],
}
