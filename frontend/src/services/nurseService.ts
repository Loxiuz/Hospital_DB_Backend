import api from './api';
import { Nurse } from '../types';

export const nurseService = {
  getAll: async (): Promise<Nurse[]> => {
    const response = await api.get<Nurse[]>('/nurses/all');
    return response.data;
  },

  getById: async (id: string): Promise<Nurse> => {
    const response = await api.get<Nurse>(`/nurses/${id}`);
    return response.data;
  }
};

