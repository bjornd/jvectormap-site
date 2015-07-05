# encoding: utf-8

module MenuHelper
  def build_menu(params={})
    @params = params
    @selected_items = get_parent_items(params[:current_item])

    items = get_children(@selected_items[-params[:level]])
    if params[:level] == 1
      items.unshift ({
        title: @selected_items[-1][:title],
        path: @selected_items[-1].path,
        current: params[:current_item].path == '/'
      })
    end

    return items
  end

  def get_children(item, depth = 1)
    item.children.dup
      .select { |item| !item.binary? }
      .sort! { |a, b| a[:order] <=> b[:order] }
      .map do |i|
        children = get_children(i, depth+1)
        {
          title: i[:title],
          path: (i[:link_to_first_child] && children) ? children[0][:path] : i.path,
          current: i.path == @params[:current_item].path,
          selected: @selected_items[-(@params[:level]+depth)] && i.path == @selected_items[-(@params[:level]+depth)].path,
          children: depth < @params[:depth] ? children : nil
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