function current_toplevel
    node -e "const state = $(lswt -j); console.log(state.toplevels.find(a => a.activated)['app-id'])"
end
