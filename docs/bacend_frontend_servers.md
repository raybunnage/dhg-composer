## to kill
lsof -i :8001
kill -9 $(lsof -t -i:8001)

lsof -i :5173
kill -9 $(lsof -t -i:5173)

## to start

cd backend
venv\Scripts\activate
source venv/bin/activate
python --version
uvicorn main:app --reload --port 8001


## in a new terminal

cd frontend
npm install
npm run dev
