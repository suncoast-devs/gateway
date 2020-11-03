// TODO: catch errors and return them
export async function get(path, params = {}) {
  // TODO: handle this smarter, dont mangle the URL if there are already params present in the path.
  const query = new URLSearchParams(params).toString()
  if (query.length > 0) path += '?' + query
  const response = await fetch(path, {
    headers: { 'Content-Type': 'application/json' },
  })
  const json = await response.json()
  return { data: json, error: null, headers: response.headers }
}

export async function post(path, params = {}) {
  const response = await fetch(path, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(params),
  })
  const json = await response.json()
  return { data: json, error: null, headers: response.headers }
}

export async function getPages(path, params = {}) {
  const { data, error, headers } = await get(path, params)
  const count = parseInt(headers.get('Total-Count'))
  const pages = parseInt(headers.get('Total-Pages'))
  const { first, next, prev, last } = parseLinks(headers.get('Link'))
  return { data, count, pages, first, next, prev, last, error, headers }
}

function parseLinks(link) {
  if (typeof link !== 'string') return {}
  return link.split(', ').reduce((result, part) => {
    let match = part.match('<(.*?)>; rel="(.*?)"')
    if (match && match.length === 3) result[match[2]] = match[1]
    return result
  }, {})
}
