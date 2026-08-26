jest.mock('../../../src/models', () => {
  const mockSequelize = { transaction: jest.fn() };
  return {
    Task: {
      findOne: jest.fn(),
      create: jest.fn(),
      count: jest.fn(),
      findAll: jest.fn(),
      findAndCountAll: jest.fn(),
      sequelize: {
        transaction: jest.fn()
      }
    },
    Rabbit: { findOne: jest.fn() },
    Cage: { findOne: jest.fn() },
    User: { findOne: jest.fn() },
    sequelize: mockSequelize
  };
});

jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(),
  error: jest.fn(),
  warn: jest.fn()
}));

const { Task, Rabbit, Cage, User } = require('../../../src/models');
const taskService = require('../../../src/services/taskService');

const createMockTask = (overrides = {}) => ({
  id: 1,
  farm_id: 1,
  title: 'Feed rabbits',
  description: 'Daily feeding',
  type: 'feeding',
  status: 'pending',
  priority: 'medium',
  due_date: new Date('2026-02-24'),
  rabbit_id: null,
  cage_id: null,
  assigned_to: null,
  created_by: 1,
  is_recurring: false,
  recurrence_rule: null,
  reminder_before: null,
  notes: null,
  toJSON: function () { return { ...this }; },
  update: jest.fn().mockResolvedValue(true),
  destroy: jest.fn().mockResolvedValue(true),
  ...overrides
});

describe('TaskService', () => {
  beforeEach(() => jest.clearAllMocks());

  // ─── createTask ───────────────────────────────────────────────────────────

  describe('createTask', () => {
    it('should create a task successfully with no rabbit/cage/assignee', async () => {
      const mockTask = createMockTask();
      Task.create.mockResolvedValue(mockTask);
      Task.findOne.mockResolvedValue(mockTask);

      const result = await taskService.createTask({
        title: 'Feed rabbits',
        type: 'feeding',
        farm_id: 1, author_id: 1
      });

      // Ферма проставляется в самой записи: без неё хук из tenancy.js
      // не даст создать задачу.
      expect(Task.create).toHaveBeenCalledWith(expect.objectContaining({ farm_id: 1 }));
      expect(result).toBeDefined();
    });

    it('should throw RABBIT_NOT_FOUND when rabbit_id is given but rabbit does not exist', async () => {
      Rabbit.findOne.mockResolvedValue(null);

      await expect(
        taskService.createTask({ title: 'Check rabbit', rabbit_id: 99, farm_id: 1, author_id: 1 })
      ).rejects.toThrow('RABBIT_NOT_FOUND');

      expect(Task.create).not.toHaveBeenCalled();
    });

    it('should throw CAGE_NOT_FOUND when cage_id is given but cage does not exist', async () => {
      Cage.findOne.mockResolvedValue(null);

      await expect(
        taskService.createTask({ title: 'Clean cage', cage_id: 99, farm_id: 1, author_id: 1 })
      ).rejects.toThrow('CAGE_NOT_FOUND');

      expect(Task.create).not.toHaveBeenCalled();
    });

    // Проверяется не существование пользователя, а принадлежность ферме:
    // иначе задачу можно было подсунуть работнику соседнего хозяйства.
    it('should throw ASSIGNEE_NOT_FOUND when assignee is from another farm', async () => {
      User.findOne.mockResolvedValue(null);

      await expect(
        taskService.createTask({ title: 'Task', assigned_to: 99, farm_id: 1, author_id: 1 })
      ).rejects.toThrow('ASSIGNEE_NOT_FOUND');

      expect(User.findOne).toHaveBeenCalledWith({ where: { id: 99, farm_id: 1 } });

      expect(Task.create).not.toHaveBeenCalled();
    });

    it('should throw INVALID_RECURRENCE_RULE when recurrence_rule is not a valid option', async () => {
      await expect(
        taskService.createTask({ title: 'Bad recurrence', recurrence_rule: 'every_full_moon', farm_id: 1, author_id: 1 })
      ).rejects.toThrow('INVALID_RECURRENCE_RULE');

      expect(Task.create).not.toHaveBeenCalled();
    });

    it('should create a task with a valid recurrence_rule', async () => {
      const mockTask = createMockTask({ is_recurring: true, recurrence_rule: 'daily' });
      Task.create.mockResolvedValue(mockTask);
      Task.findOne.mockResolvedValue(mockTask);

      const result = await taskService.createTask({
        title: 'Daily feeding',
        recurrence_rule: 'daily',
        is_recurring: true,
        farm_id: 1, author_id: 1
      });

      expect(Task.create).toHaveBeenCalled();
      expect(result).toBeDefined();
    });

    it('should create a task without recurrence_rule (non-recurring)', async () => {
      const mockTask = createMockTask();
      Task.create.mockResolvedValue(mockTask);
      Task.findOne.mockResolvedValue(mockTask);

      const result = await taskService.createTask({
        title: 'One-time task',
        farm_id: 1, author_id: 1
      });

      expect(Task.create).toHaveBeenCalled();
      expect(result).toBeDefined();
    });

    it('should create a task with valid rabbit, cage, and assignee', async () => {
      Rabbit.findOne.mockResolvedValue({ id: 1 });
      Cage.findOne.mockResolvedValue({ id: 2 });
      User.findOne.mockResolvedValue({ id: 3, farm_id: 1 });

      const mockTask = createMockTask({ rabbit_id: 1, cage_id: 2, assigned_to: 3 });
      Task.create.mockResolvedValue(mockTask);
      Task.findOne.mockResolvedValue(mockTask);

      const result = await taskService.createTask({
        title: 'Complex task',
        rabbit_id: 1,
        cage_id: 2,
        assigned_to: 3,
        farm_id: 1, author_id: 1
      });

      expect(result).toBeDefined();
      // Кролик и клетка ищутся в своей ферме, а не по всей базе.
      expect(Rabbit.findOne).toHaveBeenCalledWith({ where: { id: 1, farm_id: 1 } });
      expect(Cage.findOne).toHaveBeenCalledWith({ where: { id: 2, farm_id: 1 } });
      expect(Task.create).toHaveBeenCalledWith(expect.objectContaining({ farm_id: 1 }));
    });
  });

  // ─── getTaskById ──────────────────────────────────────────────────────────

  describe('getTaskById', () => {
    it('should return task when found', async () => {
      const mockTask = createMockTask();
      Task.findOne.mockResolvedValue(mockTask);

      const result = await taskService.getTaskById(1, 1);

      expect(result).toBe(mockTask);
      expect(Task.findOne).toHaveBeenCalledWith(
        expect.objectContaining({ where: { id: 1, farm_id: 1 } })
      );
    });

    it('should throw TASK_NOT_FOUND when task does not exist', async () => {
      Task.findOne.mockResolvedValue(null);

      await expect(taskService.getTaskById(999, 1)).rejects.toThrow('TASK_NOT_FOUND');
    });
  });

  // ─── listTasks ────────────────────────────────────────────────────────────

  describe('listTasks', () => {
    it('should return paginated tasks with default filters', async () => {
      Task.findAndCountAll.mockResolvedValue({ count: 2, rows: [createMockTask(), createMockTask({ id: 2 })] });

      const result = await taskService.listTasks(1);

      // Список фермы отбирается по её колонке, а не по составу участников:
      // «кто внёс» никогда не был признаком «чьё».
      expect(Task.findAndCountAll.mock.calls[0][0].where).toEqual({ farm_id: 1 });
      expect(result.items).toHaveLength(2);
      expect(result.total).toBe(2);
      expect(result.page).toBe(1);
      expect(result.limit).toBe(10);
    });

    it('should apply type/status/priority filters', async () => {
      Task.findAndCountAll.mockResolvedValue({ count: 1, rows: [createMockTask({ type: 'vet', status: 'in_progress', priority: 'high' })] });

      const result = await taskService.listTasks(1, { type: 'vet', status: 'in_progress', priority: 'high' });

      expect(result.items).toHaveLength(1);
      const callArg = Task.findAndCountAll.mock.calls[0][0];
      expect(callArg.where.type).toBe('vet');
      expect(callArg.where.status).toBe('in_progress');
      expect(callArg.where.priority).toBe('high');
    });

    it('should apply overdue_only filter', async () => {
      Task.findAndCountAll.mockResolvedValue({ count: 0, rows: [] });

      await taskService.listTasks(1, { overdue_only: 'true' });

      const callArg = Task.findAndCountAll.mock.calls[0][0];
      expect(callArg.where.due_date).toBeDefined();
    });

    it('should apply today_only filter', async () => {
      Task.findAndCountAll.mockResolvedValue({ count: 0, rows: [] });

      await taskService.listTasks(1, { today_only: 'true' });

      const callArg = Task.findAndCountAll.mock.calls[0][0];
      expect(callArg.where.due_date).toBeDefined();
    });

    it('should apply date range filters', async () => {
      Task.findAndCountAll.mockResolvedValue({ count: 0, rows: [] });

      await taskService.listTasks(1, { from_date: '2026-01-01', to_date: '2026-12-31' });

      const callArg = Task.findAndCountAll.mock.calls[0][0];
      expect(callArg.where.due_date).toBeDefined();
    });
  });

  // ─── updateTask ───────────────────────────────────────────────────────────

  describe('updateTask', () => {
    it('should throw TASK_NOT_FOUND when task does not exist', async () => {
      Task.findOne.mockResolvedValue(null);

      await expect(taskService.updateTask(999, 1, { title: 'New title' })).rejects.toThrow('TASK_NOT_FOUND');
    });

    it('should update task successfully', async () => {
      const mockTask = createMockTask();
      const updatedTask = createMockTask({ title: 'Updated' });
      Task.findOne
        .mockResolvedValueOnce(mockTask)
        .mockResolvedValueOnce(updatedTask);

      const result = await taskService.updateTask(1, 1, { title: 'Updated' });

      expect(mockTask.update).toHaveBeenCalled();
      expect(result).toBe(updatedTask);
    });

    it('should set completed_at when status becomes completed', async () => {
      const mockTask = createMockTask();
      Task.findOne.mockResolvedValue(mockTask);

      await taskService.updateTask(1, 1, { status: 'completed' });

      const updateArg = mockTask.update.mock.calls[0][0];
      expect(updateArg.completed_at).toBeInstanceOf(Date);
    });

    it('should clear completed_at when status is not completed', async () => {
      const mockTask = createMockTask({ status: 'completed' });
      Task.findOne.mockResolvedValue(mockTask);

      await taskService.updateTask(1, 1, { status: 'pending' });

      const updateArg = mockTask.update.mock.calls[0][0];
      expect(updateArg.completed_at).toBeNull();
    });

    it('should throw RABBIT_NOT_FOUND when updating to a non-existent rabbit', async () => {
      const mockTask = createMockTask({ rabbit_id: 5 });
      Task.findOne.mockResolvedValueOnce(mockTask);
      Rabbit.findOne.mockResolvedValue(null);

      await expect(taskService.updateTask(1, 1, { rabbit_id: 99 })).rejects.toThrow('RABBIT_NOT_FOUND');
    });

    it('should throw CAGE_NOT_FOUND when updating to a non-existent cage', async () => {
      const mockTask = createMockTask({ cage_id: 5 });
      Task.findOne.mockResolvedValueOnce(mockTask);
      Cage.findOne.mockResolvedValue(null);

      await expect(taskService.updateTask(1, 1, { cage_id: 99 })).rejects.toThrow('CAGE_NOT_FOUND');
    });

    it('should throw ASSIGNEE_NOT_FOUND when updating to a user from another farm', async () => {
      const mockTask = createMockTask();
      Task.findOne.mockResolvedValueOnce(mockTask);
      User.findOne.mockResolvedValue(null);

      await expect(taskService.updateTask(1, 1, { assigned_to: 99 })).rejects.toThrow('ASSIGNEE_NOT_FOUND');
      expect(mockTask.update).not.toHaveBeenCalled();
    });

    it('should succeed when assigned_to points to a member of the same farm', async () => {
      const mockTask = createMockTask();
      const updatedTask = createMockTask({ assigned_to: 5 });
      Task.findOne
        .mockResolvedValueOnce(mockTask)
        .mockResolvedValueOnce(updatedTask);
      User.findOne.mockResolvedValue({ id: 5, farm_id: 1 });

      const result = await taskService.updateTask(1, 1, { assigned_to: 5 });

      expect(User.findOne).toHaveBeenCalledWith({ where: { id: 5, farm_id: 1 } });
      expect(mockTask.update).toHaveBeenCalled();
      expect(result).toBe(updatedTask);
    });
  });

  // ─── deleteTask ───────────────────────────────────────────────────────────

  describe('deleteTask', () => {
    it('should delete task successfully', async () => {
      const mockTask = createMockTask();
      Task.findOne.mockResolvedValue(mockTask);

      const result = await taskService.deleteTask(1, 1);

      expect(mockTask.destroy).toHaveBeenCalled();
      expect(result).toEqual({ success: true });
    });

    it('should throw TASK_NOT_FOUND when task does not exist', async () => {
      Task.findOne.mockResolvedValue(null);

      await expect(taskService.deleteTask(999, 1)).rejects.toThrow('TASK_NOT_FOUND');
    });
  });

  // ─── getStatistics ────────────────────────────────────────────────────────

  describe('getStatistics', () => {
    it('should return full statistics object', async () => {
      Task.count.mockResolvedValue(5);
      Task.findAll.mockResolvedValue([
        { type: 'feeding', dataValues: { count: '3' } },
        { type: 'vet', dataValues: { count: '2' } }
      ]);

      // 8 Promise.all calls: 6 x count + 2 x findAll
      Task.count
        .mockResolvedValueOnce(5)  // pending
        .mockResolvedValueOnce(2)  // in_progress
        .mockResolvedValueOnce(10) // completed
        .mockResolvedValueOnce(1)  // cancelled
        .mockResolvedValueOnce(3)  // overdue
        .mockResolvedValueOnce(1); // today

      const mockTypeRows = [{ type: 'feeding', dataValues: { count: '3' } }];
      const mockPriorityRows = [{ priority: 'high', dataValues: { count: '2' } }];
      Task.findAll
        .mockResolvedValueOnce(mockTypeRows)
        .mockResolvedValueOnce(mockPriorityRows);

      const result = await taskService.getStatistics(1);

      expect(Task.count.mock.calls[0][0].where).toEqual(expect.objectContaining({ farm_id: 1 }));
      expect(result.total_pending).toBe(5);
      expect(result.total_in_progress).toBe(2);
      expect(result.total_completed).toBe(10);
      expect(result.total_cancelled).toBe(1);
      expect(result.overdue_count).toBe(3);
      expect(result.today_count).toBe(1);
      expect(result.tasks_by_type).toEqual([{ type: 'feeding', count: 3 }]);
      expect(result.tasks_by_priority).toEqual([{ priority: 'high', count: 2 }]);
    });
  });

  // ─── getUpcoming ─────────────────────────────────────────────────────────

  describe('getUpcoming', () => {
    it('should return upcoming tasks for default 7 days', async () => {
      const mockTasks = [createMockTask(), createMockTask({ id: 2 })];
      Task.findAll.mockResolvedValue(mockTasks);

      const result = await taskService.getUpcoming(1);

      expect(result).toBe(mockTasks);
      const callArg = Task.findAll.mock.calls[0][0];
      expect(callArg.where.farm_id).toBe(1);
      expect(callArg.order).toEqual([['due_date', 'ASC'], ['priority', 'DESC']]);
    });

    it('should respect custom days parameter', async () => {
      Task.findAll.mockResolvedValue([]);

      await taskService.getUpcoming(1, 14);

      expect(Task.findAll).toHaveBeenCalled();
    });
  });

  // ─── completeTask ─────────────────────────────────────────────────────────

  describe('completeTask', () => {
    const mockTransaction = { commit: jest.fn(), rollback: jest.fn(), LOCK: { UPDATE: 'UPDATE' }, finished: false };

    beforeEach(() => {
      Task.sequelize.transaction.mockResolvedValue(mockTransaction);
    });

    it('should throw TASK_NOT_FOUND when task does not exist', async () => {
      Task.findOne.mockResolvedValue(null);

      await expect(taskService.completeTask(999, 1)).rejects.toThrow('TASK_NOT_FOUND');
    });

    it('should complete a non-recurring task', async () => {
      const mockTask = createMockTask({ is_recurring: false });
      Task.findOne.mockResolvedValue(mockTask);

      const result = await taskService.completeTask(1, 1);

      expect(mockTask.update).toHaveBeenCalledWith(
        expect.objectContaining({ status: 'completed' }),
        expect.objectContaining({ transaction: mockTransaction })
      );
      expect(mockTransaction.commit).toHaveBeenCalled();
      expect(result).toBe(mockTask);
    });

    it('should create a next recurring task when completing a recurring task', async () => {
      const pastDue = new Date('2026-02-20');
      const mockTask = createMockTask({
        is_recurring: true,
        recurrence_rule: 'daily',
        due_date: pastDue
      });
      Task.findOne.mockResolvedValue(mockTask);
      Task.create.mockResolvedValue({});

      await taskService.completeTask(1, 1);

      // Следующее повторение — тоже запись фермы, farm_id обязателен.
      expect(Task.create).toHaveBeenCalledWith(
        expect.objectContaining({ is_recurring: true, status: 'pending', farm_id: 1 }),
        expect.objectContaining({ transaction: mockTransaction })
      );
      expect(mockTransaction.commit).toHaveBeenCalled();
    });

    it('should rollback transaction on error', async () => {
      const mockTask = createMockTask({ is_recurring: false });
      Task.findOne.mockResolvedValue(mockTask);
      mockTask.update.mockRejectedValueOnce(new Error('DB_ERROR'));

      await expect(taskService.completeTask(1, 1)).rejects.toThrow('DB_ERROR');
      expect(mockTransaction.rollback).toHaveBeenCalled();
    });

    const recurrenceTypes = ['weekly', 'biweekly', 'monthly', 'quarterly', 'yearly'];

    recurrenceTypes.forEach((rule) => {
      it(`should create next task for ${rule} recurrence`, async () => {
        const pastDue = new Date('2026-01-01');
        const mockTask = createMockTask({
          is_recurring: true,
          recurrence_rule: rule,
          due_date: pastDue
        });
        Task.findOne.mockResolvedValue(mockTask);
        Task.create.mockResolvedValue({});

        await taskService.completeTask(1, 1);

        expect(Task.create).toHaveBeenCalledWith(
          expect.objectContaining({ is_recurring: true, recurrence_rule: rule }),
          expect.any(Object)
        );
      });
    });
  });
});
