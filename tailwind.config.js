import forms from "@tailwindcss/forms"
import typography from "@tailwindcss/typography"

export default {
  content: [
    "./app/views/**/*.{erb,html}",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
  ],
  theme: {
    extend: {},
  },
  plugins: [forms, typography],
}
