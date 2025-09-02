json.extract! screenshot, :main

json.url polymorphic_url(screenshot.file.variant(:webp))
