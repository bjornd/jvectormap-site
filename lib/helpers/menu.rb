# encoding: utf-8

module MenuHelper
  def build_menu(params={})
    params[:items].reject { |i| !i[:title] }.sort! { |a, b| a[:order] <=> b[:order] }.map do |i|
      {
        title: i[:title],
        path: i.path,
        current: i.path == params[:current_item].path
      }
    end
  end
end