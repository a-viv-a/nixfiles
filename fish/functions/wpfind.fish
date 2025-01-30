function wpfind
    pw-dump | node -e "
const stdin = process.stdin
let data = ''
stdin.setEncoding('utf8')

stdin.on('data', c => data += c)
stdin.on('error', console.error)

stdin.on('end', () => {
  const j = JSON.parse(data)
  console.log(j$argv[1])
})
"
end
