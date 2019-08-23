function p = prof(matrix,i,j);

p = permute(matrix(i,j,:),[3 1 2]);