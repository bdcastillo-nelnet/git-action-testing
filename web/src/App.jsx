import { useEffect, useState } from 'react'
import './App.css'

// Set these in web/.env:
//   VITE_USERS_API_URL=<pull_users function url>
//   VITE_CREATE_USER_API_URL=<create_user function url>
const USERS_API_URL = import.meta.env.VITE_USERS_API_URL
const CREATE_USER_API_URL = import.meta.env.VITE_CREATE_USER_API_URL

function App() {
  const [users, setUsers] = useState([])
  const [status, setStatus] = useState('loading') // loading | ready | error | no-api

  const [firstName, setFirstName] = useState('')
  const [lastName, setLastName] = useState('')
  const [saving, setSaving] = useState(false)
  const [formError, setFormError] = useState('')

  function loadUsers() {
    if (!USERS_API_URL) {
      setStatus('no-api')
      return
    }
    setStatus('loading')
    fetch(USERS_API_URL)
      .then((res) => res.json())
      .then((data) => {
        setUsers(data.users ?? [])
        setStatus('ready')
      })
      .catch(() => setStatus('error'))
  }

  useEffect(() => {
    loadUsers()
  }, [])

  async function handleSubmit(e) {
    e.preventDefault()
    setFormError('')

    if (!CREATE_USER_API_URL) {
      setFormError('Set VITE_CREATE_USER_API_URL in web/.env')
      return
    }
    if (!firstName.trim() || !lastName.trim()) {
      setFormError('Both first and last name are required.')
      return
    }

    setSaving(true)
    try {
      const res = await fetch(CREATE_USER_API_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ first_name: firstName, last_name: lastName }),
      })
      if (!res.ok) throw new Error('Request failed')
      setFirstName('')
      setLastName('')
      loadUsers() // refresh the list with the new user
    } catch {
      setFormError('Could not create user. Try again.')
    } finally {
      setSaving(false)
    }
  }

  return (
    <div className="app">
      <h1>Users</h1>

      <form onSubmit={handleSubmit} className="create-user-form">
        <input
          type="text"
          placeholder="First name"
          value={firstName}
          onChange={(e) => setFirstName(e.target.value)}
        />
        <input
          type="text"
          placeholder="Last name"
          value={lastName}
          onChange={(e) => setLastName(e.target.value)}
        />
        <button type="submit" disabled={saving}>
          {saving ? 'Adding…' : 'Add user'}
        </button>
      </form>
      {formError && <p className="form-error">{formError}</p>}

      {status === 'loading' && <p>Loading…</p>}
      {status === 'error' && <p>Failed to load users.</p>}
      {status === 'no-api' && <p>Set VITE_USERS_API_URL in web/.env to load users.</p>}

      {status === 'ready' &&
        (users.length === 0 ? (
          <p>No users yet.</p>
        ) : (
          <ul>
            {users.map((u) => (
              <li key={u.user_id}>
                {u.first_name} {u.last_name}
              </li>
            ))}
          </ul>
        ))}
    </div>
  )
}

export default App
