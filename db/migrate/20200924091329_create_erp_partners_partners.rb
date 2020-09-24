class CreateErpPartnersPartners < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_partners_partners do |t|
      t.string :image_url
      t.string :name
      t.string :website
      t.string :address
      t.references :country, index: true, references: :erp_areas_countries
      t.references :state, index: true, references: :erp_areas_states
      t.references :district, index: true, references: :erp_areas_districts
      t.string :alias
      t.text :short_description
      t.references :creator, index: true, references: :erp_users

      t.timestamps
    end
  end
end
