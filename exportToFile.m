function [factors, means, variances] = exportToFile(folderpath, ans)
   
   factors = full(ans.extras.As);
   means = ans.extras.bs;
   variances = ans.extras.vs;
   
   [m, n] = size(factors);
   
   element_count_by_row = sum(factors ~= 0, 2);
   directly_connected_mask = element_count_by_row == 1;
   
   factors_direct = factors(directly_connected_mask, :);
   means_direct = means(directly_connected_mask);
   variances_direct = variances(directly_connected_mask);
   
   factors(directly_connected_mask, :) = [];
   means(directly_connected_mask) = [];
   variances(directly_connected_mask) = [];
   
   factors = [eye(n); factors];
   means = [zeros(n, 1); means];
   variances = [ones(n, 1) .* 1e30; variances];
   
   [row, col] = find(factors_direct == 1);  
   means(col) = means_direct(row);
   variances(col) = variances_direct(row);
   
   dlmwrite(folderpath + "/factors.txt", factors, 'delimiter', '\t', 'precision', 6);
   dlmwrite(folderpath + "/means.txt", means, 'delimiter', '\t', 'precision', 6);
   dlmwrite(folderpath + "/variances.txt", variances, 'delimiter', '\t', 'precision', 6);
   
end

