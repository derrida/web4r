[p (loop for page from link-start to link-end
         do (if (= page current-page)
                [b page]
                [a :href (concat "?page=" page) page])
         unless (= page link-end) collect (safe "&nbsp;"))]
