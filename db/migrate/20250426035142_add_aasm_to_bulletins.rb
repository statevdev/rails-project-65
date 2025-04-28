# frozen_string_literal: true

class AddAasmToBulletins < ActiveRecord::Migration[7.1]
  def change
    add_column :bulletins, :state, :string
  end
end
