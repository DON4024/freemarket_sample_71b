class ProductsController < ApplicationController

  def index
    @products = Product.includes(:images).order('created_at DESC')
  end
  
  def new
    @product = Product.new
    @product.images.new

      #セレクトボックスの初期値設定
    @category_parent_array = ["---"]
    Category.where(ancestry: nil).each do |parent|
      @category_parent_array << parent.name
    end
  end
  
  def get_category_children
    #選択された親カテゴリーに紐付く子カテゴリーの配列を取得
    @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
  end

    # 子カテゴリーが選択された後に動くアクション
  def get_category_grandchildren
    #選択された子カテゴリーに紐付く孫カテゴリーの配列を取得
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end
  
  def create
    @product = Product.new(product_params)
    categoryId_params
    if @product.save 
      
      redirect_to root_path
    else
      redirect_to new_product_path
    end
  end
  
  def edit
  end
  
  def update
    if @product.update(product_params)
      redirect_to root_path
    else
      render :edit
    end
  end
  
  def destroy
  end

  private

  def product_params
    # params.require(:product).permit(:name, :price, :description, :status, :user_id, images_attributes: [:image])

    # #ログインできるようになったらこちらに変える
    params.require(:product).permit(:name, :price, :description, :status_id, :brand, :burden_id, :days_id, :prefecture_id, images_attributes: [:image]).merge(user_id: current_user.id)
  end

  def categoryId_params
    category=params.permit(:category_id)
    @product[:category_id] = category[:category_id]
  end

  def set_product
    @product = Product.find(params[:id])
  end

end
