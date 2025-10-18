json.extract! person, :id, :name, :created_at, :updated_at

json.picture person.picture.attached? ? polymorphic_url(person.picture.variant(:webp)) : nil
