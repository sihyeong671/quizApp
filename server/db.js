import UserModel from "./model/users.js";

function add(id, name, image, score, callback) {
    const newUser = new UserModel({
        userID: id, nickName: name, img: image, score: score,
    });
    newUser.save((error, result) => {
        callback(result);
    })
}

export default {
    add
}