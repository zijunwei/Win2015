## Win2015 Detailed Write Up
</br>
</br>

### Data

1. In **DataFromServer**, there are 2 folders:
   * **fv_thread** the saved threads for each video. (The empty threads are deleted)
   * **ClipSets** the txt files containing the split of files for training and testing for each category.
2.  **DataActionMat** contains the training data for 12 categories. For the training data. The positive training sample is the sum of all threads in each positive video. The negative training sample is the different combinations [ e.g., there are n threads in a video, we generate x=C(n,n-1)+C(n,n-2)+...C(n,n-m+1)) training examples for negative data.]. Since different categories take different video and positve or negative, so there training matrix are totally different from each other.
3. **DataUseful**
   * **fv_train_td_struct** saves the structures of each training data. combination of threads names and corresponding fisher vector.
   * **clipset_mac** saves the absolute file path for training and testing splits for each categories.
   * **fv_thread** all the threads' fisher vectors in Hollywood 2 dataset.