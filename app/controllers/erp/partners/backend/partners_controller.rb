module Erp
  module Partners
    module Backend
      class PartnersController < Erp::Backend::BackendController
        before_action :set_partner, only: [:edit, :update, :destroy]
        before_action :set_partners, only: [:delete_all]
    
        # GET /partners
        def index
        end
    
        # POST /partners/list
        def list
          @partners = Partner.search(params).paginate(:page => params[:page], :per_page => 20)
          
          render layout: nil
        end
    
        # GET /partners/new
        def new
          @partner = Partner.new
        end
    
        # GET /partners/1/edit
        def edit
        end
    
        # POST /partners
        def create
          @partner = Partner.new(partner_params)
          @partner.creator = current_user
    
          if @partner.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @partner.name,
                value: @partner.id
              }
            else
              redirect_to erp_partners.edit_backend_partner_path(@partner), notice: t('.success')
            end
          else
            render :new        
          end
        end
    
        # PATCH/PUT /partners/1
        def update
          if @partner.update(partner_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @partner.name,
                value: @partner.id
              }              
            else
              redirect_to erp_partners.edit_backend_partner_path(@partner), notice: t('.success')
            end
          else
            render :edit
          end
        end
    
        # DELETE /partners/1
        def destroy
          @partner.destroy

          respond_to do |format|
            format.html { redirect_to erp_partners.backend_partners_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # DELETE ALL /partners/delete_all?ids=1,2,3
        def delete_all         
          @partners.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        # DATASELECT
        def dataselect
          respond_to do |format|
            format.json {
              render json: Partner.dataselect(params[:keyword])
            }
          end
        end
    
        private
          # Use callbacks to share common setup or constraints between actions.
          def set_partner
            @partner = Partner.find(params[:id])
          end
          
          def set_partners
            @partners = Partner.where(id: params[:ids])
          end
    
          # Only allow a trusted parameter "white list" through.
          def partner_params
            params.fetch(:partner, {}).permit(:image_url, :name, :website, :address, :country_id, :state_id, :district_id, :short_description)
          end
      end
    end
  end
end