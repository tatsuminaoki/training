module SortUtility extend ActiveSupport::Concern
  # get sort order from parameter
  def sort_order
    'desc'.casecmp(params[:order]) == 0 ? 'desc' : 'asc'
  end

  # get sort column from parameter
  def sort_column(clazz, default='id')
    clazz.column_names.include?(params[:sort]) ? params[:sort] : default
  end
end
