import React, { useEffect, useState } from 'react';
import axios from 'axios';

interface User {
  id: number;
  name: string;
  email: string;
  phone: string;
  message?: string;
  createdAt: string;
}

interface HealthStatus {
  status: string;
  message: string;
  version: string;
  timestamp: string;
}

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8080';

export default function App() {
  const [users, setUsers] = useState<User[]>([]);
  const [healthStatus, setHealthStatus] = useState<HealthStatus | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    phone: '',
    message: ''
  });
  const [editingId, setEditingId] = useState<number | null>(null);

  // Fetch health status
  useEffect(() => {
    checkHealth();
  }, []);

  // Fetch users
  useEffect(() => {
    fetchUsers();
  }, []);

  const checkHealth = async () => {
    try {
      const response = await axios.get(`${API_URL}/api/v1/health`);
      setHealthStatus(response.data);
    } catch (err) {
      console.error('Health check failed:', err);
    }
  };

  const fetchUsers = async () => {
    setLoading(true);
    try {
      const response = await axios.get(`${API_URL}/api/v1/users`);
      setUsers(response.data.content || []);
      setError(null);
    } catch (err) {
      setError('Failed to fetch users');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleCreateOrUpdate = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      if (editingId) {
        await axios.put(`${API_URL}/api/v1/users/${editingId}`, formData);
        setEditingId(null);
      } else {
        await axios.post(`${API_URL}/api/v1/users`, formData);
      }
      setFormData({ name: '', email: '', phone: '', message: '' });
      await fetchUsers();
      setError(null);
    } catch (err: any) {
      setError(err.response?.data?.message || 'Failed to save user');
    } finally {
      setLoading(false);
    }
  };

  const handleEdit = (user: User) => {
    setEditingId(user.id);
    setFormData({
      name: user.name,
      email: user.email,
      phone: user.phone,
      message: user.message || ''
    });
  };

  const handleDelete = async (id: number) => {
    if (window.confirm('Are you sure?')) {
      try {
        await axios.delete(`${API_URL}/api/v1/users/${id}`);
        await fetchUsers();
      } catch (err) {
        setError('Failed to delete user');
      }
    }
  };

  const handleCancel = () => {
    setEditingId(null);
    setFormData({ name: '', email: '', phone: '', message: '' });
  };

  return (
    <div className="min-h-screen bg-gray-100">
      {/* Header */}
      <header className="bg-blue-600 text-white shadow">
        <div className="max-w-6xl mx-auto px-4 py-6">
          <h1 className="text-3xl font-bold">Krishna DevOps Multi-Service App</h1>
          <p className="text-blue-100 mt-2">Production-ready microservices platform</p>
        </div>
      </header>

      {/* Health Status */}
      {healthStatus && (
        <div className="bg-green-50 border-l-4 border-green-500 p-4 m-4">
          <div className="flex">
            <div className="flex-shrink-0">
              <span className="text-green-500 text-2xl">✓</span>
            </div>
            <div className="ml-3">
              <p className="text-sm text-green-700">
                <strong>Status:</strong> {healthStatus.status} - {healthStatus.message}
              </p>
              <p className="text-xs text-gray-500 mt-1">Version: {healthStatus.version}</p>
            </div>
          </div>
        </div>
      )}

      {/* Main Content */}
      <main className="max-w-6xl mx-auto px-4 py-8">
        {error && (
          <div className="bg-red-50 border-l-4 border-red-500 p-4 mb-4">
            <p className="text-red-700">{error}</p>
          </div>
        )}

        <div className="grid md:grid-cols-2 gap-8">
          {/* Form */}
          <div className="bg-white rounded-lg shadow-lg p-6">
            <h2 className="text-2xl font-bold mb-4 text-gray-800">
              {editingId ? 'Edit User' : 'Add New User'}
            </h2>
            <form onSubmit={handleCreateOrUpdate} className="space-y-4">
              <div>
                <label className="block text-gray-700 font-medium mb-2">Name</label>
                <input
                  type="text"
                  required
                  value={formData.name}
                  onChange={(e) => setFormData({...formData, name: e.target.value})}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                  placeholder="Your name"
                />
              </div>
              <div>
                <label className="block text-gray-700 font-medium mb-2">Email</label>
                <input
                  type="email"
                  required
                  value={formData.email}
                  onChange={(e) => setFormData({...formData, email: e.target.value})}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                  placeholder="your@email.com"
                />
              </div>
              <div>
                <label className="block text-gray-700 font-medium mb-2">Phone</label>
                <input
                  type="tel"
                  required
                  value={formData.phone}
                  onChange={(e) => setFormData({...formData, phone: e.target.value})}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                  placeholder="Your phone number"
                />
              </div>
              <div>
                <label className="block text-gray-700 font-medium mb-2">Message</label>
                <textarea
                  value={formData.message}
                  onChange={(e) => setFormData({...formData, message: e.target.value})}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                  placeholder="Your message"
                  rows={4}
                />
              </div>
              <div className="flex gap-2">
                <button
                  type="submit"
                  disabled={loading}
                  className="flex-1 bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 disabled:bg-gray-400"
                >
                  {loading ? 'Saving...' : (editingId ? 'Update' : 'Create')}
                </button>
                {editingId && (
                  <button
                    type="button"
                    onClick={handleCancel}
                    className="flex-1 bg-gray-400 text-white px-4 py-2 rounded-lg hover:bg-gray-500"
                  >
                    Cancel
                  </button>
                )}
              </div>
            </form>
          </div>

          {/* Users List */}
          <div className="bg-white rounded-lg shadow-lg p-6">
            <h2 className="text-2xl font-bold mb-4 text-gray-800">Users</h2>
            {loading && <p className="text-gray-500">Loading...</p>}
            {!loading && users.length === 0 && <p className="text-gray-500">No users yet</p>}
            <div className="space-y-3 max-h-96 overflow-y-auto">
              {users.map((user) => (
                <div key={user.id} className="border border-gray-200 rounded-lg p-3 hover:bg-gray-50">
                  <h3 className="font-semibold text-gray-800">{user.name}</h3>
                  <p className="text-sm text-gray-600">{user.email}</p>
                  <p className="text-sm text-gray-600">{user.phone}</p>
                  {user.message && <p className="text-sm text-gray-500 mt-1">{user.message}</p>}
                  <div className="flex gap-2 mt-3">
                    <button
                      onClick={() => handleEdit(user)}
                      className="text-sm bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-600"
                    >
                      Edit
                    </button>
                    <button
                      onClick={() => handleDelete(user.id)}
                      className="text-sm bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600"
                    >
                      Delete
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="bg-gray-800 text-white mt-12 py-6">
        <div className="max-w-6xl mx-auto px-4 text-center">
          <p>© 2024 Krishna DevOps Training. Production-ready microservices platform.</p>
        </div>
      </footer>
    </div>
  );
}
