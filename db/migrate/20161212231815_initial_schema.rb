class InitialSchema < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'citext'

    create_table(:hospitals) do |t|
      t.string :slug,     null: false
      t.string :name,     null: false
      t.citext :acronym,  null: false
      t.string :url
      t.string :street
      t.string :street_number
      t.string :city
      t.string :postal_code
      t.string :country_code

      t.index :slug,              unique: true
      t.index [:name, :acronym],  unique: true

      t.timestamps
    end

    create_table(:users) do |t|
      t.belongs_to :hospital, foreign_key: true

      t.boolean :admin, null: false, default: false

      t.string :email,  null: false
      t.string :nickname
      t.string :first_name
      t.string :last_name
      t.string :locale, null: false, default: 'en'

      t.decimal :weight

      t.timestamps
    end

    create_table(:departments) do |t|
      t.belongs_to :hospital, null: false, foreign_key: true
      t.string :slug,   null: false
      t.string :title,  null: false

      t.string :director_name
      t.string :org_code
      t.string :department_page_url
      t.string :contact_phones, array: true
      t.integer :number_of_patients

      t.boolean :published
      t.belongs_to :creator, references: :users, null: false, index: true

      t.timestamps
    end
    add_foreign_key :departments, :users, column: :creator_id

    create_table(:clinics) do |t|
      t.belongs_to :department, null: false, foreign_key: true
      t.string :title, null: false

      t.belongs_to :author, references: :users, null: false, index: true

      t.timestamps
    end
    add_foreign_key :clinics, :users, column: :author_id

    create_table(:wards) do |t|
      t.belongs_to :department, null: false, foreign_key: true
      t.string :name, null: false
      t.boolean :emergency, null: false, default: false
      t.string :url

      t.string :category
      t.text :description

      t.integer :up_votes_count,    null: false, default: 0
      t.integer :down_votes_count,  null: false, default: 0

      t.belongs_to :creator, references: :users, null: false, index: true

      t.timestamps
    end
    add_foreign_key :wards, :users, column: :creator_id

    create_table(:user_wards) do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :ward, null: false, foreign_key: true
    end

    create_table(:employees) do |t|
      t.belongs_to :clinic, null: false, foreign_key: true

      t.text :biography
      t.text :biography_html
      t.text :notes
      t.text :notes_html

      t.integer :up_votes_count,    null: false, default: 0
      t.integer :down_votes_count,  null: false, default: 0

      t.string :status, null: false, default: 'current'

      t.belongs_to :author, references: :users, null: false, index: true

      t.timestamps
    end
    add_foreign_key :employees, :users, column: :author_id

    create_table(:qualifications) do |t|
      t.belongs_to :employee, null: false

      t.text :name

      t.integer :position

      t.timestamps
    end
    add_foreign_key :qualifications, :employees, on_update: :cascade,
                                                 on_delete: :cascade

    create_table :threads do |t|
      t.belongs_to :subject, polymorphic: true, index: true, null: false
      t.string :title
    end

    create_table :comments do |t|
      t.belongs_to :thread,   null: false, index: true, foreign_key: true
      t.belongs_to :author,   null: false, index: true
      t.belongs_to :reply_to, index: true

      t.string :status, null: false, default: 'published'

      t.text    :message,   null: false
      t.boolean :published, null: false, default: true

      t.timestamps null: false
    end

    add_foreign_key :comments, :users,    column: :author_id,
                                          on_update: :cascade
    add_foreign_key :comments, :comments, column: :reply_to_id

    create_table :comment_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :comment_hierarchies, [:ancestor_id, :descendant_id, :generations],
              unique: true,
              name: 'comment_anc_desc_idx'

    add_index :comment_hierarchies, [:descendant_id],
              name: 'comment_desc_idx'

    create_table :bookmarks do |t|
      t.belongs_to :bookmarkable, polymorphic: true, index: true, null: false
      t.belongs_to :user, index: true, null: false

      t.timestamps null: true
    end
    add_index :bookmarks, [:user_id, :bookmarkable_type, :bookmarkable_id], unique: true, name: :unique_by_user_and_bookmarkable

    create_table :votes do |t|
      t.belongs_to :votable, polymorphic: true, index: true, null: false
      t.belongs_to :user, index: true, null: false
      t.string :direction, null: false, index: true

      t.timestamps null: true
    end
    add_index :votes, [:user_id, :votable_type, :votable_id], unique: true
  end
end
