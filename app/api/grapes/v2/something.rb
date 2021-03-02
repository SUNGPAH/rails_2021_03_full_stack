module Grapes 
	module V2
		class Something < Grapes::API
			resource :something do 
				get do 
					return {
						success: true
					}
				end
			end
		end
	end
end 