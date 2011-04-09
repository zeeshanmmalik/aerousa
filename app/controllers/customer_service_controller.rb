class CustomerServiceController < ApplicationController
  before_filter :login_required
  require_role ["supporter"]
  layout 'main'
  def index
  end

  def view
    if params[:search]=="email"  # search both "email" and "billing_email" fields
      query = "SELECT * from clients WHERE " + params[:search] +
              " LIKE '%" + params[:query] + "%' OR billing_email" + 
              " LIKE '%" + params[:query] + "%'"
    else
      query = "SELECT * from clients WHERE " + params[:search] +
              " LIKE '%" + params[:query] + "%'"
    end

    # for each unique orderID, build the list of items in the order
    @rawclients = Client.find_by_sql query
    @clients = []
    @numItemsInOrder = Hash.new()
    for client in @rawclients
        if not client.order_no.index('~') then  #this is a main order ID, no ~
            @numItemsInOrder[client.order_no] = 1
            for subitem in @rawclients
              if subitem.order_no.index(client.order_no) then
                #this is a subitem of the current main order ID
                client.product_title += "<br/>" + subitem.product_title
                @numItemsInOrder[client.order_no] += 1
              end
          end
          @clients << client
        end
    end
    
  end

end
