jest.mock('../../../src/services/taskService');
jest.mock('../../../src/utils/logger', () => ({
  info: jest.fn(),
  error: jest.fn(),
  warn: jest.fn()
}));

const taskService = require('../../../src/services/taskService');
const taskController = require('../../../src/controllers/taskController');

const mockReq = (overrides = {}) => ({
  user: { id: 1 },
  params: {},
  body: {},
  query: {},
  ...overrides
});

const mockRes = () => {
  const res = {};
  res.status = jest.fn().mockReturnValue(res);
  res.json = jest.fn().mockReturnValue(res);
  res.send = jest.fn().mockReturnValue(res);
  return res;
};

const mockNext = jest.fn();

describe('TaskController', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('create', () => {
    it('should create task and return 201', async () => {
      const task = { id: 1, title: 'Feed rabbits' };
      taskService.createTask.mockResolvedValue(task);
      const req = mockReq({ body: { title: 'Feed rabbits' } });
      const res = mockRes();

      await taskController.create(req, res, mockNext);

      expect(taskService.createTask).toHaveBeenCalledWith({ title: 'Feed rabbits', user_id: 1 });
      expect(res.status).toHaveBeenCalledWith(201);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: task }));
    });

    it('should return 404 when RABBIT_NOT_FOUND', async () => {
      taskService.createTask.mockRejectedValue(new Error('RABBIT_NOT_FOUND'));
      const req = mockReq({ body: { rabbit_id: 99 } });
      const res = mockRes();

      await taskController.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 404 when CAGE_NOT_FOUND', async () => {
      taskService.createTask.mockRejectedValue(new Error('CAGE_NOT_FOUND'));
      const req = mockReq({ body: { cage_id: 99 } });
      const res = mockRes();

      await taskController.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 404 when ASSIGNEE_NOT_FOUND', async () => {
      taskService.createTask.mockRejectedValue(new Error('ASSIGNEE_NOT_FOUND'));
      const req = mockReq({ body: { assignee_id: 99 } });
      const res = mockRes();

      await taskController.create(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      taskService.createTask.mockRejectedValue(err);
      const req = mockReq({ body: {} });
      const res = mockRes();

      await taskController.create(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('getById', () => {
    it('should return task with 200', async () => {
      const task = { id: 1, title: 'Feed rabbits' };
      taskService.getTaskById.mockResolvedValue(task);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await taskController.getById(req, res, mockNext);

      expect(taskService.getTaskById).toHaveBeenCalledWith('1', 1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: task }));
    });

    it('should return 404 when TASK_NOT_FOUND', async () => {
      taskService.getTaskById.mockRejectedValue(new Error('TASK_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' } });
      const res = mockRes();

      await taskController.getById(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      taskService.getTaskById.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await taskController.getById(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('list', () => {
    it('should return task list with 200', async () => {
      const result = { items: [{ id: 1 }], total: 1 };
      taskService.listTasks.mockResolvedValue(result);
      const req = mockReq({ query: { status: 'pending' } });
      const res = mockRes();

      await taskController.list(req, res, mockNext);

      expect(taskService.listTasks).toHaveBeenCalledWith(1, { status: 'pending' });
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: result }));
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      taskService.listTasks.mockRejectedValue(err);
      const req = mockReq({});
      const res = mockRes();

      await taskController.list(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('update', () => {
    it('should update task and return 200', async () => {
      const task = { id: 1, title: 'Updated task' };
      taskService.updateTask.mockResolvedValue(task);
      const req = mockReq({ params: { id: '1' }, body: { title: 'Updated task' } });
      const res = mockRes();

      await taskController.update(req, res, mockNext);

      expect(taskService.updateTask).toHaveBeenCalledWith('1', 1, { title: 'Updated task' });
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: task }));
    });

    it('should return 404 when TASK_NOT_FOUND', async () => {
      taskService.updateTask.mockRejectedValue(new Error('TASK_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' }, body: {} });
      const res = mockRes();

      await taskController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 404 when RABBIT_NOT_FOUND on update', async () => {
      taskService.updateTask.mockRejectedValue(new Error('RABBIT_NOT_FOUND'));
      const req = mockReq({ params: { id: '1' }, body: { rabbit_id: 99 } });
      const res = mockRes();

      await taskController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 404 when CAGE_NOT_FOUND on update', async () => {
      taskService.updateTask.mockRejectedValue(new Error('CAGE_NOT_FOUND'));
      const req = mockReq({ params: { id: '1' }, body: { cage_id: 99 } });
      const res = mockRes();

      await taskController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should return 404 when ASSIGNEE_NOT_FOUND on update', async () => {
      taskService.updateTask.mockRejectedValue(new Error('ASSIGNEE_NOT_FOUND'));
      const req = mockReq({ params: { id: '1' }, body: { assignee_id: 99 } });
      const res = mockRes();

      await taskController.update(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      taskService.updateTask.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' }, body: {} });
      const res = mockRes();

      await taskController.update(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('delete', () => {
    it('should delete task and return 200', async () => {
      taskService.deleteTask.mockResolvedValue();
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await taskController.delete(req, res, mockNext);

      expect(taskService.deleteTask).toHaveBeenCalledWith('1', 1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: null }));
    });

    it('should return 404 when TASK_NOT_FOUND', async () => {
      taskService.deleteTask.mockRejectedValue(new Error('TASK_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' } });
      const res = mockRes();

      await taskController.delete(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      taskService.deleteTask.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await taskController.delete(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('getStatistics', () => {
    it('should return statistics with 200', async () => {
      const stats = { total: 20, completed: 15, pending: 5 };
      taskService.getStatistics.mockResolvedValue(stats);
      const req = mockReq({});
      const res = mockRes();

      await taskController.getStatistics(req, res, mockNext);

      expect(taskService.getStatistics).toHaveBeenCalledWith(1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: stats }));
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      taskService.getStatistics.mockRejectedValue(err);
      const req = mockReq({});
      const res = mockRes();

      await taskController.getStatistics(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('getUpcoming', () => {
    it('should return upcoming tasks with default 7 days', async () => {
      const tasks = [{ id: 1, due_date: '2025-02-25' }];
      taskService.getUpcoming.mockResolvedValue(tasks);
      const req = mockReq({ query: {} });
      const res = mockRes();

      await taskController.getUpcoming(req, res, mockNext);

      expect(taskService.getUpcoming).toHaveBeenCalledWith(1, 7);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: tasks }));
    });

    it('should return upcoming tasks with custom days param', async () => {
      const tasks = [{ id: 1, due_date: '2025-03-01' }];
      taskService.getUpcoming.mockResolvedValue(tasks);
      const req = mockReq({ query: { days: '14' } });
      const res = mockRes();

      await taskController.getUpcoming(req, res, mockNext);

      expect(taskService.getUpcoming).toHaveBeenCalledWith(1, '14');
      expect(res.status).toHaveBeenCalledWith(200);
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      taskService.getUpcoming.mockRejectedValue(err);
      const req = mockReq({ query: {} });
      const res = mockRes();

      await taskController.getUpcoming(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });

  describe('completeTask', () => {
    it('should complete task and return 200', async () => {
      const task = { id: 1, status: 'completed' };
      taskService.completeTask.mockResolvedValue(task);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await taskController.completeTask(req, res, mockNext);

      expect(taskService.completeTask).toHaveBeenCalledWith('1', 1);
      expect(res.status).toHaveBeenCalledWith(200);
      expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: true, data: task }));
    });

    it('should return 404 when TASK_NOT_FOUND', async () => {
      taskService.completeTask.mockRejectedValue(new Error('TASK_NOT_FOUND'));
      const req = mockReq({ params: { id: '99' } });
      const res = mockRes();

      await taskController.completeTask(req, res, mockNext);

      expect(res.status).toHaveBeenCalledWith(404);
      expect(mockNext).not.toHaveBeenCalled();
    });

    it('should call next for unexpected errors', async () => {
      const err = new Error('DB error');
      taskService.completeTask.mockRejectedValue(err);
      const req = mockReq({ params: { id: '1' } });
      const res = mockRes();

      await taskController.completeTask(req, res, mockNext);

      expect(mockNext).toHaveBeenCalledWith(err);
    });
  });
});
