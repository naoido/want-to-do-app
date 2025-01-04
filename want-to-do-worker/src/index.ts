import { Hono } from 'hono'

type Bindings = {
  KV: KVNamespace
}

const app = new Hono<{ Bindings: Bindings }>()

app.get('/api/items', async (c) => {
  const item = await c.env.KV.get('todo-list')
  return c.json(item)
})

app.post('/api/items', async (c) => {
  const value = await c.req.json()
  let old = await c.env.KV.get('todo-list', { type: 'json' }) as any
  if (!old) {
    old = {todo_list: [], group_user_ids: [], name: "やりたいことリスト"}
  }
  const todoList = old.todo_list;
  todoList.push(value);

  old["todo_list"] = todoList
  await c.env.KV.put("todo-list", JSON.stringify(old))

  return c.json({success: true})
})

app.patch('/api/items', async (c) => {
  const value = await c.req.json()
  let old = (await c.env.KV.get('todo-list', { type: 'json' }) as any);

  old.todo_list = old.todo_list.map((item: { id: any }) => {
      if (item.id === value.id) {
          return { ...item, ...value };
      }
      return item;
  });

  await c.env.KV.put('todo-list', JSON.stringify(old));

  return c.json({ success: true, old })
})
export default app
