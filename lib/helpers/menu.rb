# encoding: utf-8

module MenuHelper
  def build_menu(params={})
    @params = params
    selected_items = get_parent_items(params[:current_item])
    
    items = get_children(selected_items[-params[:level]])
    if params[:level] == 1
      items.unshift ({
        title: selected_items[-1][:title],
        path: selected_items[-1].path,
        current: params[:current_item].path == '/'
      })
    end
    
    return items
  end
  
  def get_children(item, depth = 1)
    item.children.dup
      .sort! { |a, b| a[:order] <=> b[:order] }
      .map do |i|
        {
          title: i[:title],
          path: i.path,
          current: i.path == @params[:current_item].path,
          children: depth < @params[:depth] ? get_children(i, depth+1) : nil
        }
      end
  end
  
  def get_parent_items(item)
    chain = [item]
    if item.parent
      chain.concat(get_parent_items(item.parent))
    else
      chain
    end
  end
  
  def get_root_item(items)
    @root_item ||= items[items.index { |i| i.path == '/' }]
  end
end