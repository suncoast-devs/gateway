export async function get(path, params = {}) {
  const query = new URLSearchParams(params).toString()
  if (query.length > 0) path += '?' + query
  const response = await fetch(path, {
    headers: { 'Content-Type': 'application/json' },
  })
  const json = await response.json()
  return json
}

export async function post(path, params = {}) {
  const response = await fetch(path, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(params),
  })
  const json = await response.json()
  return json
}
