from flask import Flask, request, jsonify
from pymongo import MongoClient

app = Flask(__name__)

# MongoDB Atlas connection
client = MongoClient(
    "mongodb+srv://mrksrout_db_user:Mongo12345@cluster0.tlsegtu.mongodb.net/assignmentDB?retryWrites=true&w=majority"
)

db = client["assignmentDB"]
collection = db["items"]

@app.route("/", methods=["GET"])
def home():
    return jsonify({"message": "Flask backend with MongoDB is running"}), 200


# Add item
@app.route("/submit", methods=["POST"])
def submit():
    try:
        data = request.get_json()

        item = {
            "item_id": data.get("item_id"),
            "name": data.get("name"),
            "description": data.get("description")
        }

        collection.insert_one(item)

        return jsonify({
            "status": "success",
            "item": item
        }), 200

    except Exception as e:
        print("Submit error:", e)
        return jsonify({
            "status": "error",
            "message": "Failed to insert item"
        }), 500


# Get all items
@app.route("/items", methods=["GET"])
def get_items():
    items = list(collection.find({}, {"_id": 0}))
    return jsonify(items), 200


# Get item by ID
@app.route("/items/<item_id>", methods=["GET"])
def get_item(item_id):
    item = collection.find_one({"item_id": item_id}, {"_id": 0})
    if item:
        return jsonify(item), 200
    return jsonify({"error": "Item not found"}), 404


# Count items
@app.route("/count", methods=["GET"])
def count_items():
    total = collection.count_documents({})
    return jsonify({"total_items": total}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

