import UserModel from "./model/users.js";

function add(id, name, image, callback) {
    const newUser = new UserModel({
        userID: id, nickName: name, img: image
    });
    newUser.save((error, result) => {
        callback(result);
    })
}

export default {
    add
}