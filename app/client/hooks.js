import { useState, useEffect } from 'react'

export const useModelData = (queryFunction, defaultData = []) => {
  const [forceUpdate, setForceUpdate] = useState(true) // boolean state

  const [loading, setLoading] = useState(true)
  const [data, setData] = useState(defaultData)

  useEffect(() => {
    queryFunction().then(function(response) {
      setData(response.data)
      setLoading(false)
    })
  }, [forceUpdate])

  return { loading, data, reload: () => setForceUpdate(!forceUpdate) }
}
