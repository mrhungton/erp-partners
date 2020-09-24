module Erp::Partners
  class Partner < ApplicationRecord
    mount_uploader :image_url, Erp::Partners::PartnerUploader
    
    belongs_to :creator, class_name: "Erp::User"
    belongs_to :country, class_name: "Erp::Areas::Country", optional: true
    belongs_to :state, class_name: "Erp::Areas::State", optional: true
    belongs_to :district, class_name: "Erp::Areas::District", optional: true
    
    validates :name, uniqueness: true
    validates :image_url, presence: true
    
    after_create :create_alias
    def create_alias
			name = self.name
			self.update_column(:alias, name.to_ascii.downcase.to_s.gsub(/[^0-9a-z ]/i, '').gsub(/ +/i, '-').strip)
    end
    
    # country name
    def country_name
      country.present? ? country.name : ''
    end

    # state name
    def state_name
      state.present? ? state.name : ''
    end

    # district name
    def district_name
      district.present? ? district.name : ''
    end
    
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []

      #filters
      if params["filters"].present?
        params["filters"].each do |ft|
          or_conds = []
          ft[1].each do |cond|
              or_conds << "#{cond[1]["name"]} = '#{cond[1]["value"]}'"
          end
          and_conds << '('+or_conds.join(' OR ')+')' if !or_conds.empty?
        end
      end

      #keywords
      if params["keywords"].present?
        params["keywords"].each do |kw|
          or_conds = []
          kw[1].each do |cond|
            or_conds << "LOWER(#{cond[1]["name"]}) LIKE '%#{cond[1]["value"].downcase.strip}%'"
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
      end

      # join with users table for search creator
      query = query.joins(:creator)

      # add conditions to query
      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?

      return query
    end

    def self.search(params)
      query = self.all
      query = self.filter(query, params)

      # order
      if params[:sort_by].present?
        order = params[:sort_by]
        order += " #{params[:sort_direction]}" if params[:sort_direction].present?

        query = query.order(order)
      end

      return query
    end

    # data for dataselect ajax
    def self.dataselect(keyword='')
      query = self.all

      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ?', "%#{keyword}%")
      end

      query = query.limit(8).map{|partner| {value: partner.id, text: partner.name} }
    end
    
    def self.get_all
      self.all.order("created_at DESC")
    end
    
    def get_name
      self.name
    end
    
  end
end