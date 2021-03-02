module Grapes 
	module V1
		class Movies < Grapes::API
			resource :movies do 
				get do 
					return {
						success: true
					}
				end
			end
		end
	end
end 