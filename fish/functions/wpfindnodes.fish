function wpfindnodes
    wpfind "
      .filter(c => c.type == 'PipeWire:Interface:Node')
      .filter(c => c.info.props['node.description'] !== undefined)
      .filter(c => c.info.props['media.class'] === '$argv[1]')
      .map(c => [c.info.props['object.id'], c.info.props['node.description']].join('\t'))
      .join('\n')
    "
end
