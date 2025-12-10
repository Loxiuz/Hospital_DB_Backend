import React, { useEffect, useState } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import { doctorService } from '../../services/doctorService';
import { wardService } from '../../services/wardService';
import { DoctorRequest, DoctorSpecialityType, Ward } from '../../types';
import { LoadingSpinner } from '../../components/common/LoadingSpinner';
import { ErrorMessage } from '../../components/common/ErrorMessage';

export const DoctorForm: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const isEdit = !!id;
  const [loading, setLoading] = useState(isEdit);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [wards, setWards] = useState<Ward[]>([]);
  const [loadingOptions, setLoadingOptions] = useState(true);

  const [formData, setFormData] = useState<DoctorRequest>({
    doctorName: '',
    speciality: DoctorSpecialityType.GENERAL_MEDICINE,
    wardId: ''
  });

  useEffect(() => {
    loadOptions();
    if (isEdit && id) {
      loadDoctor(id);
    }
  }, [id, isEdit]);

  const loadOptions = async () => {
    try {
      setLoadingOptions(true);
      const wardsData = await wardService.getAll();
      setWards(wardsData);
    } catch (err: any) {
      console.error('Failed to load wards:', err);
    } finally {
      setLoadingOptions(false);
    }
  };

  const loadDoctor = async (doctorId: string) => {
    try {
      setLoading(true);
      const doctor = await doctorService.getById(doctorId);
      setFormData({
        doctorName: doctor.doctorName,
        speciality: doctor.speciality,
        wardId: doctor.ward?.wardId || ''
      });
      setError(null);
    } catch (err: any) {
      setError(err.response?.data?.message || 'Failed to load doctor');
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(null);
    setSaving(true);

    try {
      if (isEdit && id) {
        await doctorService.update(id, formData);
      } else {
        await doctorService.create(formData);
      }
      navigate('/doctors');
    } catch (err: any) {
      setError(err.response?.data?.message || `Failed to ${isEdit ? 'update' : 'create'} doctor`);
    } finally {
      setSaving(false);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <LoadingSpinner size="large" />
      </div>
    );
  }

  return (
    <div>
      <div className="mb-6">
        <Link to="/doctors" className="text-blue-600 hover:text-blue-800">
          ← Back to Doctors
        </Link>
      </div>

      <div className="bg-white shadow sm:rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <h3 className="text-lg leading-6 font-medium text-gray-900 mb-4">
            {isEdit ? 'Edit Doctor' : 'Create New Doctor'}
          </h3>

          {error && <ErrorMessage message={error} onDismiss={() => setError(null)} />}

          <form onSubmit={handleSubmit} className="space-y-6">
            <div>
              <label htmlFor="doctorName" className="block text-sm font-medium text-gray-700">
                Doctor Name *
              </label>
              <input
                type="text"
                name="doctorName"
                id="doctorName"
                required
                value={formData.doctorName}
                onChange={handleChange}
                className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500"
              />
            </div>

            <div>
              <label htmlFor="speciality" className="block text-sm font-medium text-gray-700">
                Speciality *
              </label>
              <select
                name="speciality"
                id="speciality"
                required
                value={formData.speciality}
                onChange={handleChange}
                className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500"
              >
                <option value={DoctorSpecialityType.GENERAL_MEDICINE}>General Medicine</option>
                <option value={DoctorSpecialityType.CARDIOLOGY}>Cardiology</option>
                <option value={DoctorSpecialityType.NEUROLOGY}>Neurology</option>
                <option value={DoctorSpecialityType.SURGERY}>Surgery</option>
              </select>
            </div>

            <div>
              <label htmlFor="wardId" className="block text-sm font-medium text-gray-700">
                Ward
              </label>
              <select
                name="wardId"
                id="wardId"
                value={formData.wardId}
                onChange={handleChange}
                disabled={loadingOptions}
                className="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-blue-500 focus:border-blue-500 disabled:bg-gray-100"
              >
                <option value="">Select a ward</option>
                {wards.map((ward) => (
                  <option key={ward.wardId} value={ward.wardId}>
                    {ward.type} Ward (Capacity: {ward.maxCapacity})
                  </option>
                ))}
              </select>
            </div>

            <div className="flex justify-end space-x-3">
              <Link
                to="/doctors"
                className="bg-gray-300 hover:bg-gray-400 text-gray-800 px-4 py-2 rounded-md"
              >
                Cancel
              </Link>
              <button
                type="submit"
                disabled={saving}
                className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-md disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {saving ? <LoadingSpinner size="small" /> : (isEdit ? 'Update' : 'Create')}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

