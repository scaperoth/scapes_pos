class CreateMainSchema < ActiveRecord::Migration
    def change
        create_table 'active_admin_comments', force: true do |t|
            t.string   'namespace'
            t.text     'body'
            t.string   'resource_id',   null: false
            t.string   'resource_type', null: false
            t.integer  'author_id'
            t.string   'author_type'
            t.datetime 'created_at'
            t.datetime 'updated_at'
        end

        add_index 'active_admin_comments', %w(author_type author_id), name: 'index_active_admin_comments_on_author_type_and_author_id', using: :btree
        add_index 'active_admin_comments', ['namespace'], name: 'index_active_admin_comments_on_namespace', using: :btree
        add_index 'active_admin_comments', %w(resource_type resource_id), name: 'index_active_admin_comments_on_resource_type_and_resource_id', using: :btree

        create_table 'admin_users', force: true do |t|
            t.string   'email', default: '', null: false
            t.string   'encrypted_password', default: '', null: false
            t.string   'reset_password_token'
            t.datetime 'reset_password_sent_at'
            t.datetime 'remember_created_at'
            t.integer  'sign_in_count', default: 0, null: false
            t.datetime 'current_sign_in_at'
            t.datetime 'last_sign_in_at'
            t.inet     'current_sign_in_ip'
            t.inet     'last_sign_in_ip'
            t.datetime 'created_at',                          null: false
            t.datetime 'updated_at',                          null: false
        end

        add_index 'admin_users', ['email'], name: 'index_admin_users_on_email', unique: true, using: :btree
        add_index 'admin_users', ['reset_password_token'], name: 'index_admin_users_on_reset_password_token', unique: true, using: :btree

        create_table 'brands', force: true do |t|
            t.string   'name', null: false
            t.datetime 'created_at'
            t.datetime 'updated_at'
        end

        add_index 'brands', ['name'], name: 'index_brands_on_name', using: :btree

        create_table 'categories', force: true do |t|
            t.string   'name', null: false
            t.decimal  'price', null: false
            t.integer  'team_id', null: false
            t.datetime 'created_at'
            t.datetime 'updated_at'
        end


        create_table 'events', force: true do |t|
            t.string   'name', null: false
            t.datetime 'date'
            t.integer 'team_id', null: false
            t.boolean 'active', default: true, null: false
            t.datetime 'created_at'
            t.datetime 'updated_at'
        end

        add_index 'events', ['name'], name: 'index_events_on_name', using: :btree

        create_table 'products', force: true do |t|
            t.string   'sku', null: false
            t.decimal  'price', default: 0, null: false
            t.text     'description', default: '', null: false
            t.integer  'brand_id'
            t.integer  'category_id'
            t.integer  'team_id', null: false
            t.datetime 'created_at'
            t.datetime 'updated_at'
        end
        
        add_index 'products', ['sku'], name: 'index_products_on_sku', unique: true, using: :btree
        add_index 'products', ['category_id'], name: 'index_products_on_category_id', using: :btree
        add_index 'products', ['team_id'], name: 'index_products_on_team_id', using: :btree
        add_index 'products', ['brand_id'], name: 'index_products_on_brand_id', using: :btree

        create_table 'sale_details', force: true do |t|
            t.integer  'sale_id', null: false
            t.integer  'product_id', null: false
            t.decimal  'price', null: false
            t.integer  'quantity', null: false, default: 1
            t.decimal  'total', null: false, default: 0
            t.datetime 'created_at'
            t.datetime 'updated_at'
        end

        add_index 'sale_details', ['product_id'], name: 'index_sale_details_on_product_id', using: :btree
        add_index 'sale_details', ['sale_id'], name: 'index_sale_details_on_sale_id', using: :btree

        create_table 'sales', force: true do |t|
            t.integer  'user_id', default: '', null: false
            t.integer  'customer_id', default: '', null: false
            t.integer  'event_id', null: false
            t.decimal  'amount_paid', null: false
            t.decimal  'change', default: 0, null: false
            t.decimal 'total', null: false
            t.datetime 'created_at'
            t.datetime 'updated_at'
        end

        add_index 'sales', ['customer_id'], name: 'index_sales_on_customer_id', using: :btree
        add_index 'sales', ['user_id'], name: 'index_sales_on_user_id', using: :btree
        add_index 'sales', ['event_id'], name: 'index_sales_on_event_id', using: :btree

        create_table 'team_members', force: true do |t|
            t.integer  'team_id', null: false
            t.integer  'user_id', null: false
            t.boolean  'admin', default: false, null: false
            t.datetime 'created_at'
            t.datetime 'updated_at'
        end

        add_index 'team_members', ['team_id'], name: 'index_team_members_on_team_id', using: :btree
        add_index 'team_members', ['user_id'], name: 'index_team_members_on_user_id', using: :btree
        add_index "team_members", ["user_id", "team_id"], name: "index_team_members_on_user_id_and_team_id", unique: true, using: :btree

        create_table 'teams', force: true do |t|
            t.string   'name', null: false
            t.datetime 'created_at'
            t.datetime 'updated_at'
        end

        create_table 'users', force: true do |t|
            t.string   'email', default: '', null: false
            t.string   'encrypted_password', default: '', null: false
            t.string   'reset_password_token'
            t.datetime 'reset_password_sent_at'
            t.datetime 'remember_created_at'
            t.integer  'sign_in_count', default: 0, null: false
            t.datetime 'current_sign_in_at'
            t.datetime 'last_sign_in_at'
            t.inet     'current_sign_in_ip'
            t.inet     'last_sign_in_ip'
            t.datetime 'created_at',                          null: false
            t.datetime 'updated_at',                          null: false
            t.string   'username'
        end

        add_index 'users', ['email'], name: 'index_users_on_email', unique: true, using: :btree
        add_index 'users', ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true, using: :btree
        add_index 'users', ['username'], name: 'index_users_on_username', unique: true, using: :btree

        create_table 'votes', force: true do |t|
            t.integer  'votable_id'
            t.string   'votable_type'
            t.integer  'voter_id'
            t.string   'voter_type'
            t.boolean  'vote_flag'
            t.string   'vote_scope'
            t.integer  'vote_weight'
            t.datetime 'created_at'
            t.datetime 'updated_at'
        end

        add_index 'votes', %w(votable_id votable_type vote_scope), name: 'index_votes_on_votable_id_and_votable_type_and_vote_scope', using: :btree
        add_index 'votes', %w(voter_id voter_type vote_scope), name: 'index_votes_on_voter_id_and_voter_type_and_vote_scope', using: :btree
      end
end
