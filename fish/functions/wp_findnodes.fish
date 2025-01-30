function wp_findnodes
    wp_find "
      .filter(c => c.type == 'PipeWire:Interface:Node')
      .filter(c => c.info.props['node.description'] !== undefined)
      .map(c => [c.info.props['object.id'], c.info.props['media.class'], c.info.props['node.description']].join('\t'))
      .join('\n')
    "
end
