Erp::Partners::Engine.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
		namespace :backend, module: "backend", path: "backend/partners" do
			resources :partners do
				collection do
					post 'list'
					post 'dataselect'
					delete 'delete_all'
				end
			end
		end
	end
end