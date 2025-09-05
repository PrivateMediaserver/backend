json.extract! screenshot, :id, :main

json.url polymorphic_url(screenshot.file.variant(:webp))
