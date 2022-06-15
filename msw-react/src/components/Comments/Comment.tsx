import React from "react";
import IComment from "../../interfaces/Comment";
import styles from "./Comment.module.css";

const Comment = ({ comment }: { comment: IComment }): JSX.Element => {
  return (
    <li className={styles.comment}>
      <div className={styles.body}>{comment.body}</div>
      <div className={styles.email}>Posted by: {comment.email}</div>
    </li>
  );
};

export default Comment;
